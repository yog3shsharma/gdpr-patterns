module.exports = function () {
    return {
        files: [
            'node/jira-issues/src/**/*.coffee'
        ],

        tests: [
            'node/jira-issues/test/**/*.coffee'
        ],

        env: {
            type: 'node'
        }//,
        // workers: {
        //     initial: 1,         // without these sometimes the fluentnode apis
        //     regular: 1          // are not detected
        // }
    }
}