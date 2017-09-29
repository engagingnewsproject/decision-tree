/*
* Settings
*/
// Set this for browserSync to know where your
// url normally is.
var localhost = "dev/decision-tree";

/*
* NPM Packages
*/
const gulp = require('gulp');
const browserSync = require('browser-sync');
const sass = require('gulp-sass');
const autoprefixer = require('gulp-autoprefixer');
const reload  = browserSync.reload;
const csso = require('gulp-csso');
const uglify = require('gulp-uglify');
const rename = require("gulp-rename");
const imagemin = require('gulp-imagemin');
const svgstore = require('gulp-svgstore');
const svgmin = require('gulp-svgmin');
const path = require('path');
const concat = require("gulp-concat");
const babel = require("gulp-babel");
const plumber = require('gulp-plumber');
// Handlebars and dependencies
const handlebars = require('gulp-handlebars');
const wrap = require('gulp-wrap');
const declare = require('gulp-declare');


// Static Server + watching scss/html files
gulp.task('serve', ['sass', 'iframeJS', 'TreeJS', 'TreeLoaderJS', 'compressImg', 'svgstore', 'handlebars'], function() {

    browserSync({
        proxy: localhost
    });
    // Watch SCSS file for change to pass on to sass compiler,
    gulp.watch(['assets/sass/*.{scss,sass}','assets/sass/*/*.{scss,sass}'], ['sass']);
    // Watch SCSS file for change to pass on to sass compiler,
    gulp.watch('assets/js/iframe-parent/*.js', ['iframeJS']);
    gulp.watch('assets/js/Tree/*.js', ['TreeJS']);
    gulp.watch('assets/js/TreeLoader/*.js', ['TreeLoaderJS']);
    // run img compression when images added to directory
    gulp.watch('assets/img/*.*', ['compressImg']);
    // run SVG when svg files added
    gulp.watch('assets/svg/*.svg', ['svgstore']);
    // compile templates
    gulp.watch('templates/*.hbs', ['handlebars']);
    // compile js
    gulp.watch(["dist/js/scripts.js", "dist/js/handlebars.runtime.js", "dist/js/templates.js"], ['concatTreeJS']);
    // Watch our CSS file and reload when it's done compiling
    gulp.watch("dist/css/*.css").on('change', reload);
    // Watch php file
    gulp.watch("../*/*.php").on('change', reload);
    // watch javascript files
    gulp.watch("dist/js/cme-tree.min.js").on('change', reload);

    compressJS("dist/js/handlebars.runtime.js");
});

gulp.task('svgstore', function () {
    return gulp
        .src('assets/svg/*.svg')
        .pipe(plumber())
        .pipe(svgmin(function (file) {
            var prefix = path.basename(file.relative, path.extname(file.relative));
            return {
                plugins: [{
                    cleanupIDs: {
                        prefix: prefix + '-',
                        minify: true
                    }
                }]
            };
        }))
        .pipe(svgstore({ inlineSvg: true }))
        .pipe(gulp.dest('dist/svg/'));
});



gulp.task('sass', function () {
    processSASS('base');
});

gulp.task('TreeJS', function() {
    var jsFiles = 'assets/js/Tree/*.js',
    jsDest = 'dist/js';

    return gulp.src(jsFiles)
        .pipe(plumber())
        .pipe(babel({
            presets: ['es2015']
        }))
        .pipe(concat('scripts.js'))
        .pipe(gulp.dest(jsDest))
        .pipe(rename('scripts.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest(jsDest));
});

gulp.task('TreeLoaderJS', function() {
    var jsFiles = 'assets/js/TreeLoader/*.js',
    jsDest = 'dist/js';

    return gulp.src(jsFiles)
        .pipe(plumber())
        .pipe(babel({
            presets: ['es2015']
        }))
        .pipe(concat('TreeLoader.js'))
        .pipe(gulp.dest(jsDest))
        .pipe(rename('TreeLoader.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest(jsDest));
});

gulp.task('iframeJS', function() {
    var jsFiles = 'assets/js/iframe-parent/*.js',
    jsDest = 'dist/js';

    return gulp.src(jsFiles)
        .pipe(plumber())
        .pipe(babel({
            presets: ['es2015']
        }))
        .pipe(concat('iframe-parent.js'))
        .pipe(gulp.dest(jsDest))
        .pipe(rename('iframe-parent.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest(jsDest));
});

function compressJS(src) {

    dist = 'dist/js/';

    return gulp.src(src)
        .pipe(plumber())
        .pipe(uglify())
        .pipe(rename({
          suffix: '.min'
        }))
        .pipe(gulp.dest(dist));
}

gulp.task('concatTreeJS', function() {
    dist = 'dist/js/';
    src = [dist+'handlebars.runtime.js',
           dist+'templates.js',
           dist+'scripts.js'
       ];
    filename = 'cme-tree';

    return gulp.src(src)
    .pipe(concat('cme-tree.js'))
    .pipe(gulp.dest(dist))
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(uglify())
    .pipe(gulp.dest(dist));
});

gulp.task('compressImg', function() {
    return gulp.src('assets/img/*')
            .pipe(plumber())
            .pipe(imagemin())
            .pipe(gulp.dest('dist/img'));
});


function processSASS(filename) {
    return gulp.src('assets/sass/output/'+filename+'.{scss,sass}')
      // Converts Sass into CSS with Gulp Sass
      .pipe(plumber())
      .pipe(sass({
        errLogToConsole: true
      }))
      // adds prefixes to whatever needs to get done
      .pipe(autoprefixer())

      // minify the CSS
      .pipe(csso())

      // rename to add .min
      .pipe(rename({
        suffix: '.min'
      }))
      // Outputs CSS files in the css folder
      .pipe(gulp.dest('dist/css/'));
}

gulp.task('handlebars', function(){
  gulp.src('templates/*.hbs')
      .pipe(handlebars({
        handlebars: require('handlebars')
      }))
      .pipe(wrap('Handlebars.template(<%= contents %>)'))
      .pipe(declare({
        namespace: 'TreeTemplates',
        noRedeclare: true, // Avoid duplicate declarations
      }))
      .pipe(concat('templates.js'))
      .pipe(gulp.dest('dist/js/'))
      .pipe(rename('templates.min.js'))
      .pipe(uglify())
      .pipe(gulp.dest('dist/js/'));
});

/*gulp.task('templates', function(){
  gulp.src('templates/*.hbs')
    .pipe(handlebars({
      handlebars: require('handlebars')
    }))
    .pipe(wrap('Handlebars.template(<%= contents %>)'))
    .pipe(declare({
      namespace: 'TreeTemplates',
      noRedeclare: true, // Avoid duplicate declarations
    }))
    .pipe(concat('templates.js'))
    .pipe(gulp.dest('dist/js/'));
});*/

// Creating a default task
gulp.task('default', ['serve']);
