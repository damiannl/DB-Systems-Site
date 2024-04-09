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
	<head>
		<title>Event Manager</title>
		<script type="text/javascript" src="js/md5.js"></script>
		<script type="text/javascript" src="js/code.js"></script>
		<link href="css/styles.css" rel="stylesheet" />
		<link
		href="https://fonts.googleapis.com/css?family=Ubuntu"
		rel="stylesheet"
		/>
	</head>
	<body>
		<div id="logoIconAndName">
		<h1 id="title">Event Manager</h1>
		</div>
		<div class="loginContainer">
		<div id="loginDiv">
			<span id="inner-title">Log In</span><br />
			<label for="loginName">Email</label>
			<input type="text" id="loginName" /><br />
			<label for="loginPassword">Password</label>
			<input type="password" id="loginPassword" /><br />
			<button
			type="button"
			id="loginButton"
			class="buttons"
			onclick="doLogin();"
			>
			Log In
			</button>
			<span id="loginResult"></span>
			<br />
			<div>
			<span id="loginLinkText">Need an account? </span
			><a href="./register.html" id="loginLink">Click here</a>
			</div>
		</div>
		</div>
	</body>
</html>
