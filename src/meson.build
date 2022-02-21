project('ValaFS', 'vala', 'c')
add_project_arguments('-DFUSE_USE_VERSION=26', language: 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('fuse')
]

sources = files('main.vala')

executable('valafs', sources, dependencies: dependencies)