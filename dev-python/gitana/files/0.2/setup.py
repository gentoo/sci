#!/usr/bin/python2.7

"""
	setup module for gitana
	
	See:
	https://github.com/SOM-Research/Gitana/tree/0.2
	
	https://packaging.python.org/en/latest/distributing.html
	https://github.com/pypa/sampleproject
"""

"""from distutils.core import setup"""
from setuptools import setup

setup(name='gitana',
	version='0.2',
	license='MIT',
	author='valerio cosentino',
	url='https://github.com/SOM-Research/Gitana',
	description='SQL-based Git Repository Inspector',
	long_description='Gitana exports and digests the data of a Git repository, issue trackers and Q&A web-sites to a relational database in order to ease browsing and querying activities with standard SQL syntax and tools.',
	keywords='Gitana: SQL-based Git Repository Inspector',
	packages=['gitana'],
	package_dir={'gitana': ''},
	package_data={'gitana': ['img/*.png', 'settings/*']},
	entry_points = {
		"console_scripts": [
			"gitana_gui = gitana.gitana_gui:main",
		]
	},
)

"""py_modules=['foo'],"""
"""package_data={'mypkg': ['data/*.dat']},"""
"""data_files=[('img', ['img/*']),
				('json', ['json/*']),
				('settings', ['settings/*']),
			  ],"""
