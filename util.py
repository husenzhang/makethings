def get_fastq(sid, read='R1'):
    return '{}_{}_.fastq.gz'.format(sid, read)

sid = '555'
print(sid)
print(get_fastq(sid, read='R2'))
