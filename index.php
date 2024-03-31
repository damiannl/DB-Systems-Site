 <?php
	include 'db_connection.php';
	$conn = OpenCon();
	mysqli_close($conn);
?>
<style>
mheader {
	position: relative;
	left: 30px;
	size: 20;
}
mfooter {
	position: fixed;
	bottom: 30px;
}
a {
	color: blue;
}
</style>

<html>
	<title>UCF Events Project</title>
		<mheader>
			UCF Database Project<br>
			Authors: Joshua, Damian, Evan<br>
		</mheader>
		
		<a href="link"> Test link</a>
	
	
	
	
	
	
	<mfooter>Insert generic footer here</footer>
</html>