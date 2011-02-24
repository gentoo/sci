alter table db change kind kind enum('dna','pep') default null;
alter table db change blast_program blast_program enum('blastn', 'blastp', 'blastx', 'tblastn', 'tblastx') default null;
alter table db change rec_sim_type rec_sim_type enum('orthologue', 'synonymous') default null;
