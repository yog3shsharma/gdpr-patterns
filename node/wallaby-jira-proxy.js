module.exports = function () {
    return {
        files: [
            'jira-issues/src/**/*.coffee',
            'jira-mappings/src/**/*.coffee',
            'jira-proxy/src/**/*.coffee'
        ],

        tests: [
            'jira-proxy/test/**/*.coffee'
        ],

        env: {
            type: 'node',
            runner: 'node'
        }
    }
}