module.exports = {
    content: [
        './app/views/**/*.html.erb',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/javascript/**/*.jsx',
        './app/components/**/*.rb',
        './app/assets/stylesheets/**/*.css',
    ],
    theme: {
        extend: {
            colors: {
                'note-green': '#50d71e',
                'note-red': '#ff0000',
            },
            fontFamily: {
                sans: ['Inter', 'ui-sans-serif', 'system-ui'],
            },
        },
    },
};
