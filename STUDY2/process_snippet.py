import csv 
with open('DATA/part1_results/flattened.csv', "wb") as f:
    c = csv.writer(f) 
    c.writerow(['worker_id','gender','age','party','voting_for','state','title','source','candidate', 'flesch','is_complex','fair','trust'])
  
    for row in group_A.iterrows():
        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title1','source1','candidate1',
                           'flesch1','is_complex1','fair1', 'trust1']]))
        
        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title2','source2','candidate2',
                           'flesch2','is_complex2','fair2', 'trust2']]))

        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title3','source3','candidate3',
                           'flesch3','is_complex3','fair3', 'trust3']]))

        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title4','source4','candidate4',
                           'flesch4','is_complex4','fair4', 'trust4']]))
   
        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title5','source5','candidate5',
                           'flesch5','is_complex1','fair5', 'trust5']]))

        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title6','source6','candidate6',
                           'flesch6','is_complex6','fair6', 'trust6']]))

        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title7','source7','candidate7',
                           'flesch7','is_complex7','fair7', 'trust7']]))

        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title8','source8','candidate8',
                           'flesch8','is_complex8','fair8', 'trust8']]))

       
        