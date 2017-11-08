import hyperdex.admin
a = hyperdex.admin.Admin('192.168.0.1', 7777)
a.add_space('''
        space test
        key keystr
        attributes value
        ''')
