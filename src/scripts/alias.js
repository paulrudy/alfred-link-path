#!/usr/bin/env osascript -l JavaScript

"use strict";

function posixPath(finderRef) {
	return $.NSURL.alloc.initWithString(finderRef.url()).fileSystemRepresentation;
}

function run(argv) {
	var se = Application("System Events");
	se.includeStandardAdditions = true;
	const finder = Application("Finder");
	finder.includeStandardAdditions = true;

	const sourcePath = argv[0];
	const dirName = se.files[sourcePath].container().posixPath();

	const newAlias = finder.make({
		new: "alias",
		to: Path(sourcePath),
		at: Path(dirName),
	});

	return posixPath(newAlias);
}
