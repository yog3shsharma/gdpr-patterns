module.exports = function (wallaby) {
    return {
        files: [
            'node/jira-issues/src/**/*.coffee',
            'node/jira-mappings/src/**/*.coffee'
        ],

        tests: [
            'node/jira-issues/test/**/*.coffee'
        ],
        compilers: {
            '**/*.js?(x)': wallaby.compilers.babel({}),
        },
        env: {
            type: 'node'
        }
    }
}