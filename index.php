<?php
	include 'db_connection.php';
	$conn = OpenCon();
	mysqli_close($conn);
?>

<html>
<head>
<title>UCF Events Project</title>
<!-- Shared style sheet for all pages.-->
<link rel="stylesheet" type="text/css" href="style.css"/> 
<!-- Header content -->
<header id="app-header"></header>
<script async src="header.js"></script>
</head>
<!-- Start of index.php -->
<body>

<div class="content">
  <p>A topnav, content and a footer.</p>

  <a href="link"> Testing link</a>	
</div>

<!-- Footer content -->
<header id="app-footer"></header>
<script async src="footer.js"></script>
</body>
</html>