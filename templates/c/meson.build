project(
	'example',
	'c',
	default_options: {
		'c_std': 'c23',
		'buildtype': 'debug',
		'b_ndebug': 'if-release',
		'warning_level': '3',
	},
)

executable(
	'example',
	'src/main.c',
	sources: [
		run_command('find', 'src', '-name', '*.c', check: true).stdout().split(),
	],
	include_directories: [
		include_directories('src'),
	],
	c_args: [
		'-DVERSION="@0@"'.format(meson.project_version()),
		'-Wno-empty-translation-unit',
		'-Wno-pragma-once-outside-header',
	],
	link_args: [],
	dependencies: [],
	install: true,
)
