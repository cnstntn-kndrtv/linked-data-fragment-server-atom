let _ = require('lodash')
  , fs = require('fs')
  , path = require('path')
  , ldfs = require('ldf-server')
  , LinkedDataFragmentsServer = ldfs.LinkedDataFragmentsServer
  , IndexDatasource = ldfs.datasources.IndexDatasource
  , ViewCollection = ldfs.views.ViewCollection;

let config = JSON.parse(fs.readFileSync(__dirname + '/config-server.json')),
  workers = config.workers || 1,
  protocolMatch = (config.baseURL || '').match(/^(\w+):/),
  protocol = config.protocol = protocolMatch ? protocolMatch[1] : 'http',
  constructors = {};

const node_modules_dir = __dirname + '/../../node_modules'

let port;
if (!config.port) port = 3000;
else if (config.port == "random") port = '0';
else port = config.port;

var baseURL = config.baseURL = config.baseURL.replace(/\/?$/, '/'),
  baseURLRoot = baseURL.match(/^(?:https?:\/\/[^\/]+)?/)[0],
  baseURLPath = baseURL.substr(baseURLRoot.length),
  blankNodePath = baseURLRoot ? '/.well-known/genid/' : '',
  blankNodePrefix = blankNodePath ? baseURLRoot + blankNodePath : 'genid:';

// Create all data sources
var datasources = config.datasources,
  datasourceBase = baseURLPath.substr(1),
  dereference = config.dereference;
Object.keys(datasources).forEach(function (datasourceName) {
  var datasourceConfig = config.datasources[datasourceName],
    datasourcePath;
  delete datasources[datasourceName];
  if (datasourceConfig.enabled !== false) {
    try {
      // Avoid illegal URI characters in data source path
      datasourcePath = datasourceBase + encodeURI(datasourceName);
      datasources[datasourcePath] = datasourceConfig;
      // Set up blank-node-to-IRI translation, with dereferenceable URLs when possible
      datasourceConfig.settings = _.defaults(datasourceConfig.settings || {}, config);
      if (!datasourceConfig.settings.blankNodePrefix) {
        datasourceConfig.settings.blankNodePrefix = blankNodePrefix + datasourcePath + '/';
        if (blankNodePath)
          dereference[blankNodePath + datasourcePath + '/'] = datasourcePath;
      }
      // Create the data source
      var datasource = instantiate(datasourceConfig, '../node_modules/ldf-server/lib/datasources/');
      datasource.on('error', datasourceError);
      datasourceConfig.datasource = datasource;
      datasourceConfig.url = baseURLRoot + '/' + datasourcePath + '#dataset';
      datasourceConfig.title = datasourceConfig.title || datasourceName;
    } catch (error) {
      datasourceError(error);
    }

    function datasourceError(error) {
      delete datasources[datasourcePath];
      process.stderr.write('WARNING: skipped datasource ' + datasourceName + '. ' + error.message + '\n');
    }
  }
});

// Create index data source
var indexPath = datasourceBase.replace(/\/$/, '');
datasources[indexPath] = datasources[indexPath] || {
  url: baseURLRoot + '/' + indexPath + '#dataset',
  role: 'index',
  title: 'dataset index',
  datasource: new IndexDatasource({
    datasources: datasources
  }),
};

config.assetsPath = baseURLPath + 'assets/';
config.assetsFolder = node_modules_dir + "/ldf-server/assets"

// Set up routers, views, and controllers
config.routers = instantiateAll(config.routers, node_modules_dir + '/ldf-server/lib/routers/');
config.views = new ViewCollection();
config.views.addViews(instantiateAll(findFiles(__dirname + '/views', /\.js$/)));
//config.views.addViews(instantiateAll(findFiles('../node_modules/ldf-server/lib//views', /\.js$/)));
config.controllers = instantiateAll(config.controllers, node_modules_dir + '/ldf-server/lib/controllers/');

// Set up logging
var loggingSettings = config.logging;
config.log = console.log;
if (loggingSettings.enabled) {
  var accesslog = require('access-log');
  config.accesslogger = function (request, response) {
    accesslog(request, response, null, function (logEntry) {
      fs.appendFile(loggingSettings.file, logEntry + '\n', function (error) {
        error && process.stderr.write('Error when writing to access log file: ' + error);
      });
    });
  };
}

// Create server, and start it when all data sources are ready
var server = new LinkedDataFragmentsServer(config),
  pending = _.size(datasources);
_.each(datasources, function (settings) {
  var ready = _.once(startWhenReady);
  settings.datasource.once('initialized', ready);
  settings.datasource.once('error', ready);
});

function startWhenReady() {
  if (!--pending) {
    server.listen(port, () => {
      console.log('Server %d running on %s://localhost:%d/.', process.pid, protocol, server.address().port);
      console.log(server.address());
      // return ({process_pid: process.pid, protocol, server.adress()})
    });
  }
}

function stop() {
    server.stop();
}

// Terminate gracefully if possible
process.once('SIGINT', function () {
  console.log('Stopping server', process.pid);
  server.stop();
  process.on('SIGINT', function () {
    process.exit(1);
  });
});


// Instantiates an object from the given description
function instantiate(description, includePath) {
  var type = description.type || description,
    typePath = path.join(includePath ? path.resolve(__dirname, includePath) : '', type),
    Constructor = constructors[typePath] || (constructors[typePath] = require(typePath)),
    extensions = config.extensions && config.extensions[type] || [],
    settings = _.defaults(description.settings || {}, {
      extensions: extensions.map(function (x) {
        return instantiate(x, includePath);
      }),
    }, config);
  return new Constructor(settings, config);
}

// Instantiates all objects from the given descriptions
function instantiateAll(descriptions, includePath) {
  return (_.isArray(descriptions) ? _.map : _.mapValues)(descriptions,
    function (description) {
      return instantiate(description, includePath);
    });
}

// Recursively finds files in a folder whose name matches the pattern
function findFiles(folder, pattern, includeCurrentFolder) {
  folder = path.resolve(__dirname, folder);
  return _.flatten(_.compact(fs.readdirSync(folder).map(function (name) {
    name = path.join(folder, name);
    if (fs.statSync(name).isDirectory())
      return findFiles(name, pattern, true);
    else if (includeCurrentFolder && pattern.test(name))
      return name;
  })));
}
