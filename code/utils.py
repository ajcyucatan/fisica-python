from IPython.display import display, HTML

# String formatted as a header
def header_str(a_str, n=80):
    return '{{:=^{:d}}}'.format(n).format(' ' + a_str + ' ')

# String formatted as a HTML header
def header_html(astr, level=1):
    html_code = '<h{}>{}</h{}>'.format(level, astr, level)
    return display(HTML(html_code))
