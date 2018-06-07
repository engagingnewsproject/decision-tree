
</main>
<!-- consuming API -->
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<!-- development version, includes helpful console warnings -->
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/draggable/1.0.0-beta.7/sortable.min.js"></script>
<script type="text/javascript">
// set the tree var
var tree = <?php echo json_encode($tree->array());?>
</script>
<script type="text/javascript" src="/views/edit/dist/js/edit.js"></script>
</body>
</html>
