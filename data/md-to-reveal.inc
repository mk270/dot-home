<!doctype html>
<html lang="en">
  <head>
	<meta charset="utf-8">
	<title>Presentation</title>

	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style"
          content="black-translucent" />
	<meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, minimal-ui">

	<link rel="stylesheet" href="css/reveal.css">
	<link rel="stylesheet" href="css/theme/sky.css" id="theme">
	<link rel="stylesheet" href="lib/css/zenburn.css">
	<script src="js/header.js"></script>
	<!--[if lt IE 9]>
		<script src="lib/js/html5shiv.js"></script>
		<![endif]-->
  </head>

  <body>

	<div class="reveal">

	  <!-- Any section element inside of this container is displayed as a slide -->
	  <div class="slides">
      {% content %}
	  </div>

	</div>

	<script src="lib/js/head.min.js"></script>
	<script src="js/reveal.js"></script>
	<script src="js/footer.js"></script>
  </body>
</html>
