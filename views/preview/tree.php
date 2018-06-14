<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Example Decision Tree</title>
    <style>

        body {
            font-family: 'Trebuchet MS', 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'Tahoma', sans-serif;
            font-size: 16px;
            line-height: 1.6;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
        }

        h1,h2,h3,h4,h5,h6,p,ul,pre {
            padding: 0 20px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        header, footer {
            padding: 0 20px;
            margin: 0 auto;
        }

        header {
            border-bottom: 1px solid #ddd;
            margin-bottom: 3rem;
        }

        .site-title {
            margin: 0;
            font-size: 1rem;
            padding: 0.6rem 0;
        }

        p {
            font-size: 1rem;
            margin: 0 auto 1.6rem;
        }

        .preview-tree__wrapper {
            margin-bottom: 1.6rem;
        }

        pre {
            border: 1px solid #ddd;
            background: #f8f8f8;
            padding: 1rem;
            border-radius: 5px;
            overflow: scroll;
        }

        p code {
            padding: 0.2rem;
            background: #f8f8f8;
            border-radius: 3px;
            border: 1px solid #ddd;
        }

        h2, h3, h4 {
            margin: 3.2rem auto 0.2rem;
        }

    </style>

    <?php if($loader === 'advanced') : ?>
    <link rel='stylesheet' href="/dist/css/<?php echo $css;?>.min.css"/>
    <?php endif;?>
    <!--<link rel='stylesheet' href="/assets/base-test.css"/>-->

</head>
<body>
<header>
    <h1 class="site-title">Tree Preview</h1>
</header>
<main>
    <div class="preview-tree__wrapper">
    <?php if($loader === 'iframe') : ?>
        <script src="/dist/js/iframe-parent.js"></script>
        <iframe width="100%" height="500px" style="border: none;" id="cme-tree__<?php echo $tree->getID();?>" class="cme-tree__iframe" src="/api/v1/trees/<?php echo $tree->getSlug();?>/iframe"></iframe>
    <?php elseif ($loader === 'advanced'): ?>
        <div id="cme-tree__<?php echo $tree->getSlug();?>" >
            <noscript>
                <iframe width="100%" height="500px" src="/api/v1/trees/<?php echo $tree->getSlug();?>/iframe?js=false"></iframe>
            </noscript>
        </div>
    <?php else: // simple ?>
        <script src="/dist/js/TreeLoader.js?tree=<?php echo $tree->getSlug();?>&style=<?php echo $css;?>"></script>
        <noscript>
            <iframe width="100%" height="500px" src="api/v1/trees/<?php echo $tree->getSlug();?>/iframe?js=false"></iframe>
        </noscript>
    <?php endif; ?>
    </div>


    <section>
        <h2>Embed This Tree: Instructions</h2>

        <h3>Native Method: Easy</h3>

        <p>The native embed will be entirely on your site. You can apply your own CSS and JS interactions to the tree. You have full control over everything.</p>

<pre><code>&lt;script src="/dist/js/TreeLoader.js?tree=<?php echo $tree->getSlug();?>&style=<?php echo $css;?>">&lt;/script&gt;
&lt;noscript&gt;
    &lt;iframe width="100%" height="500px" src="api/v1/trees/<?php echo $tree->getSlug();?>/iframe?js=false"&gt;&lt;/iframe&gt;
&lt;/noscript&gt;</code></pre>

        <p>If you run into CSS conflict issues or want to customize the styles yourself, see <a href="#css-options">the CSS Options</a>. You can switch out <code>style=base</code> for the stylesheet you want to use instead, such as <code>style=structure</code></p>

        <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader=simple&css='.$css;?>">Load page with Native Method: Easy</a><?php echo ($loader === 'simple' ? ' (currently using)' : '');?></p>


        <h3>Native Method: Intermediate</h3>

        <p>The same end result as the simple native method, but you have more control over how everything is set-up, such as where and when the files get loaded. The main reason to use this would be if you already have a copy of the handlebars JS build included on your site.</p>


        <h4>CSS</h4>
        <p>In your site's head:</p>

        <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/base.min.css" /&gt;</code></pre>

        <p>If you run into CSS conflict issues or want to customize the styles yourself, see <a href="#css-options">the CSS Options</a></p>

        <h4>JS</h4>

        <p>In your site's footer, before the closing body tag:
<pre><code>&lt;script src="https://tree.mediaengagement.org/dist/js/cme-tree.js"&gt;&lt;/script&gt;

&lt;script&gt;
var treeOptions = {
        slug: '<?php echo $tree->getSlug();?>',
        container: document.getElementById('cme-tree__<?php echo $tree->getSlug();?>')
};

createTree(treeOptions);
&lt;/script&gt;</code></pre>
        </p>

        <h4>HTML</h4>
        <p>Where you want your tree embed to appear:

<pre><code>&lt;div id="cme-tree__<?php echo $tree->getSlug();?>"&gt;
&lt;noscript&gt;
    &lt;iframe width="100%" height="500px" src="api/v1/trees/<?php echo $tree->getSlug();?>/iframe?js=false"&gt;&lt;/iframe&gt;
&lt;/noscript&gt;
&lt;/div&gt;</code></pre>
        </p>

        <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader=advanced&css='.$css;?>">Load page with Native Method: Intermediate</a><?php echo ($loader === 'advanced' ? ' (currently using)' : '');?></p>

        <h3>Iframe Method: Easy</h3>
        <p>If you run into CSS or JS conflicts, you can use an iframe for the tree instead.<p>


<pre><code>&lt;script src="https://tree.mediaengagement.org/dist/js/iframe-parent.js"&gt;&lt;/script&gt;
&lt;iframe width="100%" height="500px" style="border: none;" id="cme-tree__<?php echo $tree->getID();?>" class="cme-tree__iframe" src="https//tree.mediaengagement.org/api/v1/trees/<?php echo $tree->getSlug();?>/iframe"&gt;&lt;/iframe&gt;</code></pre>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader=iframe&css='.$css;?>">Load page with Iframe Method: Easy</a><?php echo ($loader === 'iframe' ? ' (currently using)' : '');?></p>

    <h3 id="css-options">CSS Options</h3>

    <p>If you run into CSS conflict with your site, you can use a more agressive stylesheet.</p>

    <h4>base-important</h4>
    <p>Adds <code>!important</code> tags to each line of the CSS.

    <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/base-important.min.css" /&gt;</code></pre>
    </p>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader='.$loader.'&css=base-important';?>">Load page with base-important CSS</a><?php echo ($css === 'base-important' ? ' (currently using)' : '');?></p>


    <h4>base-clean-slate</h4>
    <p>A CSS reset that adds <a href="http://cleanslatecss.com/">Clean Slate CSS</a> and <code>!important</code> tags to each line of the CSS.

    <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/base-clean-slate.min.css" /&gt;</code></pre>
    </p>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader='.$loader.'&css=base-clean-slate';?>">Load page with base-clean-slate CSS</a><?php echo ($css === 'base-clean-slate' ? ' (currently using)' : '');?></p>

    <p>If you want to apply your own styles to the tree, you can use a pared down CSS file instead.</p>

    <h4>structure</h4>
    <p>Only the structure and interactions. It will look pretty strange without your own styles added :) This is the barest form of the CSS for full customization.

    <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/structure.min.css" /&gt;</code></pre>
    </p>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader='.$loader.'&css=structure';?>">Load page with structure CSS</a><?php echo ($css === 'structure' ? ' (currently using)' : '');?></p>

    <h4>structure-typography</h4>
    <p>Structure (above) and text styles

    <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/structure-typography.min.css" /&gt;</code></pre>
    </p>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader='.$loader.'&css=structure-typography';?>">Load page with structure-typography CSS</a><?php echo ($css === 'structure-typography' ? ' (currently using)' : '');?></p>

    <h4>structure-color</h4>
    <p>Includes structure (above) and colors, but no typographical styles.

    <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/structure-color.min.css" /&gt;</code></pre>
    </p>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader='.$loader.'&css=structure-color';?>">Load page with structure-color CSS</a><?php echo ($css === 'structure-color' ? ' (currently using)' : '');?></p>

    <h4>base</h4>
    <p>The default stylesheet. Includes all of the above: structure, color, and typography.

    <pre><code>&lt;link rel="stylesheet" href="https://tree.mediaengagement.org/dist/css/base.min.css" /&gt;</code></pre>
    </p>

    <p><a href="<?php echo '/preview/tree/'.$tree->getSlug().'?env='.$env.'&loader='.$loader.'&css=base';?>">Load page with base CSS</a><?php echo ($css === 'base' ? ' (currently using)' : '');?></p>

    <p>Each of the above stylesheets has an <code>!imporant</code> and clean slate option. Just add <code>-important</code> or <code>-clean-slate</code> to the end of the filename.</p>

    <p>For example, if you want the clean slate version of the structure-only version (<code>structure.min.css</code>), you would append <code>-clean-slate</code> to the filename, making it <code>structure-clean-slate.min.css</code></p>

    </section>


</main>

<?php
if($loader !== 'simple') :
    if($env === 'prod') :
        echo '<script src="/dist/js/cme-tree.js"></script>';
    elseif ($env === 'dev') :
        echo '<script src="/dist/js/handlebars.runtime.js"></script>
            <script src="/dist/js/templates.js"></script>
            <script src="/dist/js/scripts.js"></script>';
    endif;
    ?>

    <script>
    var treeOptions = {
            slug: '<?php echo $tree->getSlug();?>',
            container: document.getElementById('cme-tree__<?php echo $tree->getSlug();?>')
    };

    // you can access all your trees with var trees
    createTree(treeOptions);
    </script>
<?php endif; ?>
</body>
</html>
