project(
	'example',
	'c',
	default_options: {
		'c_std': 'c23',
		'buildtype': 'debugoptimized',
		'warning_level': '3',
	},
)

executable(
	'example',
	'src/main.c',
	c_args: [
		'-DVERSION="@0@"'.format(meson.project_version()),
		'-Wno-empty-translation-unit',
		'-Wno-pragma-once-outside-header',
	],
	link_args: [],
	dependencies: [],
	install: true,
)
