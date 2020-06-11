for fq in fqs:
    old = '{}/{}'.format('R2', fq)
    new = '{}/{}'.format('submit_R2', fq)
    os.rename(old, new)
