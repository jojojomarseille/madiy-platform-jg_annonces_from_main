const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    jquery: 'jquery/src/jquery',
    moment: 'moment'
  })
)

environment.loaders.prepend('erb', erb)
module.exports = environment
