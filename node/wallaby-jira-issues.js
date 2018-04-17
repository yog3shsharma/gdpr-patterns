module.exports = function () {
    return {
        files: [
            'jira-issues/src/**/*.coffee'
        ],

        tests: [
            'jira-issues/test/**/*.coffee'
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