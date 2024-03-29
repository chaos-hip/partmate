module.exports = {
    runtimeCompiler: true,

    devServer: {
        proxy: 'http://localhost:3000'
    },

    publicPath: process.env.NODE_ENV === 'production' ? '/ui/' : '/',
    outputDir: 'dist',
    assetsDir: 'assets',

    pages: {
        index: {
            entry: 'src/main.ts',
            template: 'public/index.html',
            filename: 'index.html',
            chunks: ['chunk-vendors', 'chunk-common', 'index']
        }
    },

    pluginOptions: {
        i18n: {
            locale: 'de',
            fallbackLocale: 'en',
            localeDir: 'locales',
            enableLegacy: false,
            runtimeOnly: false,
            compositionOnly: false,
            fullInstall: true
        }
    }
}
