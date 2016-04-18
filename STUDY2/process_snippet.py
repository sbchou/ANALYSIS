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
                           'title_2','url_2','org_2','candidate_2',
                           'flesch_2','gunning_fog_2','readability_2','top_topic_2', 'favor_2', 'trust_2']]))
        
        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title_3','url_3','org_3','candidate_3',
                           'flesch_3','gunning_fog_3','readability_3','top_topic_3', 'favor_3', 'trust_3']]))
        
        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title_4','url_4','org_4','candidate_4',
                           'flesch_4','gunning_fog_4','readability_4','top_topic_4', 'favor_4', 'trust_4']]))
       
        c.writerow(list(row[1][['_worker_id','what_is_your_gender','age_group','what_is_your_political_party_affiliation',
                           'voting_for','_region',
                           'title_5','url_5','org_5','candidate_5',
                           'flesch_5','gunning_fog_5','readability_5','top_topic_5', 'favor_5', 'trust_5']]))
       
        