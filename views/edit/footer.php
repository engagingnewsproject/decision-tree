
</main>
<!-- consuming API -->
<script src="/views/edit/dist/js/axios.js"></script>
<!-- development version, includes helpful console warnings -->
<script src="/views/edit/dist/js/vue.js"></script>
<script src="/views/edit/dist/js/sortable.js"></script>
<script type="text/javascript">
// set the tree var
var tree = <?php echo json_encode($tree->array());?>
</script>
<script type="text/javascript" src="/views/edit/dist/js/edit.js"></script>
</body>
</html>
