<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Example Decision Tree</title>
    <link rel='stylesheet' href="dist/css/base.min.css"/>
    <!--<link rel='stylesheet' href="assets/base-test.css"/>-->
    <!--<style>
        .enp-tree__question {
            border: 1px solid #ddd;
        }

        .enp-tree__content-window {
            position: relative;
        }

        .enp-tree__questions {
            transition: all .4s;
            position: relative;
        }

        .enp-tree__question {
            padding: 30px;
            margin-bottom: 30px;
        }

        .enp-tree__state--tree .enp-tree__group {
            position: absolute;
            left: 100%;
            top: 0;
        }

        .enp-tree__state--tree .enp-tree__content-window {
            transform: scale(0.5);
            transform-origin: top left;
        }

    </style>-->
</head>
<body>
<main>
    <h2>Main content block</h2>
    <div id="enp-tree__citizen">
        <noscript>
            <iframe width="100%" height="500px" src="api/v1/trees/citizen/iframe?js=false"></iframe>
        </noscript>
    </div>

</main>
<footer>
    <h2>Footer</h2>
</footer>
<script src="dist/js/handlebars.runtime.js"></script>
<script src="dist/js/templates.js"></script>
<script src="dist/js/scripts.js"></script>
<script>

    treeOptions = {
            slug: 'citizen',
            container: document.getElementById('enp-tree__citizen')
    };

    // you can access all your trees with var trees
    createTree(treeOptions);
</script>
</body>
</html>
