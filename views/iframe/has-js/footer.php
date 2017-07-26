</div>


</main>

<script src="<?php echo $url;?>/dist/js/handlebars.runtime.js"></script>
<script src="<?php echo $url;?>/dist/js/templates.js"></script>
<script src="<?php echo $url;?>/dist/js/scripts.js"></script>
<script>
treeOptions = {
        slug: '<?php echo $tree_slug;?>',
        container: document.getElementById('enp-tree')
};

var tree = new Tree(treeOptions);
</script>

</body>
</html>
