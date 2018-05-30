<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Decision Tree - <?php echo $tree->getTitle();?></title>
    <!-- consuming API -->
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <!-- development version, includes helpful console warnings -->
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

    <style>
        body {
            background: #f2f2f2;
        }
        .element {
            border: 1px solid #ddd;
            background: #fff;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
        }

        .btn--delete {
            position: absolute;
            top: 5px;
            right: 5px;
            border: none;
            color: red;
            background: none;
        }
        form {

        }
        label {
            display: block;
        }
    </style>
</head>
<body>
<main>
