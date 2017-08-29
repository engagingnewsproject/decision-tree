<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Example Decision Tree</title>
    <link rel='stylesheet' href="dist/css/base.min.css"/>
    <!--<link rel='stylesheet' href="assets/base-test.css"/>-->
    <style>

        body {
            padding: 20px;
            max-width: 1000px;
            margin: 0 auto;
        }
    </style>
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

    function focusIt(elem) {
        console.time('focus')
        elem.focus()
        console.timeEnd('focus')
    }
</script>
</body>
</html>
