module.exports = function () {
    return {
        files: [
            'node/jira-issues/src/**/*.coffee',
            'node/jira-mappings/src/**/*.coffee'
        ],

        tests: [
            'node/jira-mappings/test/**/*.coffee'
        ],

        env: {
            type: 'node'
        }
    }
}