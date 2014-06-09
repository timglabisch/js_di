module.exports = function(config) {
    config.set({
        basePath: '',
        frameworks: ['jasmine'],
        files: ['di.coffee', 'test/**.coffee'],
        preprocessors: {
            '**/*.coffee': 'coffee'
        }
    });
};
