#!/usr/bin/env ruby

# 15-2-2011 Noe Fernandez-Pozo
# Script to download Full-LengtherNext databases.
# Once in UniProtKB/Swiss-Prot, a protein entry is removed from UniProtKB/TrEMBL.

require 'net/ftp'
require 'open-uri'

class FtpClient

def initialize
end

def connect(server)
	@server=server
end

def login

end

def chdir(dir)
  @dir=dir
end

def getbinaryfile(file,output_file)
	if !File.exists?(output_file) && !File.exists?(output_file.gsub('.gz',''))
   		puts " - Downloading"
   		cmd="wget #{@server}/#{@dir}/#{file} -O #{output_file}"
   		system(cmd)
    else
    	puts "File #{output_file}, or #{output_file.gsub('.gz','')} already exists. Skip download"
    end
   
end

def close
end

end
################################################### Functions

def download_ncrna(formatted_db_path)
	
	if !File.exists?(File.join(formatted_db_path, "nc_rna_db"))
		Dir.mkdir(File.join(formatted_db_path, "nc_rna_db"))
	end
	
	puts "Downloading ncRNA database"
	open(File.join(formatted_db_path, "nc_rna_db/ncrna_fln_100.fasta.zip"), "wb") do |my_file|
	  my_file.print open('http://www.scbi.uma.es/downloads/FLNDB/ncrna_fln_100.fasta.zip').read
	end
	puts "\nncRNA database downloaded"
	
	ncrna_zip=File.join(formatted_db_path,'nc_rna_db','ncrna_fln_100.fasta.zip')
	ncrna_out_dir=File.join(formatted_db_path,'nc_rna_db')
	system("unzip", ncrna_zip, "-d", ncrna_out_dir)
	system("rm", ncrna_zip)
	
	puts "\nncRNA database decompressed"
	
	ncrna_fasta=File.join(formatted_db_path,'nc_rna_db','ncrna_fln_100.fasta')
	system("makeblastdb", "-in", ncrna_fasta, "-dbtype", "nucl", "-parse_seqids")
	
	puts "\nncRNA database completed"
end

def conecta_uniprot(my_array, formatted_db_path)
	
	#$ftp = Net::FTP.new()
	$ftp = FtpClient.new()
	
	if !File.exists?(formatted_db_path)
		Dir.mkdir(formatted_db_path)
	end
	
	$ftp.connect('ftp://ftp.uniprot.org')
	
	$ftp.login
	
	puts "connected to UniProt"
	
	my_array.each do |db_group|
		puts "Downloading #{db_group}"
		download_uniprot(db_group, formatted_db_path)
	end
	
	varsplic_out=File.join(formatted_db_path,'uniprot_sprot_varsplic.fasta.gz')
	$ftp.chdir("/pub/databases/uniprot/current_release/knowledgebase/complete")
	$ftp.getbinaryfile("uniprot_sprot_varsplic.fasta.gz", varsplic_out)
	
	puts "isoform files downloaded"
	
	$ftp.close
	
end

def download_uniprot(uniprot_group, formatted_db_path)
	
	sp_out=File.join(formatted_db_path,"uniprot_sprot_#{uniprot_group}.dat.gz")
	tr_out=File.join(formatted_db_path,"uniprot_trembl_#{uniprot_group}.dat.gz")
	$ftp.chdir("/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions")
	puts "   from ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_sprot_#{uniprot_group}.dat.gz"
	puts "   from ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_trembl_#{uniprot_group}.dat.gz"
	$ftp.getbinaryfile("uniprot_sprot_#{uniprot_group}.dat.gz", sp_out)
	$ftp.getbinaryfile("uniprot_trembl_#{uniprot_group}.dat.gz", tr_out)
	
	puts "#{uniprot_group} files downloaded"
	
end

def filter_incomplete_seqs(file_name, isoform_hash, formatted_db_path)
	
	puts "filtering sequences from #{file_name}"
	
	# UniProtKB fragments with FT NON_CONS and FT NON_TER features.
	# 
	#     * FT NON_TER: The residue at an extremity of the sequence is not the terminal residue. If applied to position 1, this signifies that the first position is not the N-terminus of the complete molecule. If applied to the last position, it means that this position is not the C-terminus of the complete molecule. There is no description field for this key. Examples of NON_TER key feature lines:
	#       FT NON_TER 1 1
	#       FT NON_TER 29 29
	#     * FT NON_CONS: Non-consecutive residues. Indicates that two residues in a sequence are not consecutive and that there are a number of unreported or missing residues between them. Example of a NON_CONS key feature line:
	#       FT NON_CONS 1683 1684
	# 
	# NON_CONS fragments are not indicated as non-consecutive in InterPro and being non-consecutive the match to methods may be incorrect if the method spans the 'break'.
	
	newseq=false
	print_seq=true
	id=''
	description = ''
	organism_name = ''
	seq = ''
	organelle = ''
	
	file_name =~ /uniprot_([a-z]+)_([a-z]+).dat/
	db_name = $1
	output_name = $2
	db_name.sub!('sprot','sp')
	db_name.sub!('trembl','tr')
	
	if !File.exists?(File.join(formatted_db_path, "#{db_name}_#{output_name}"))
		Dir.mkdir(File.join(formatted_db_path, "#{db_name}_#{output_name}"))
	end
	
	output_file = File.new(File.join(formatted_db_path, "#{db_name}_#{output_name}/#{db_name}_#{output_name}.fasta"), "w")
	
	File.open(file_name).each_line do |line|
		if (newseq == false)
			if (line =~ /^AC\s+(\w+);/)
				id=$1
				newseq = true
				description = ''
				organism_name = ''
				seq = ''
				print_seq = true
				organelle = ''
			end
		else
			if (line =~ /^DE\s+(.+)\;*/)
				if (description == '')
					description = $1
					description.sub!(/RecName: Full=/,'sp=')
					description.sub!(/SubName: Full=/,'tr=')
				end
				if (line =~ /Flags: Fragment/)
					# puts "#{id} #{line}"
					print_seq=false
				end
			elsif (line =~ /^OS\s+(.+)/)
				organism_name = $1
			elsif (line =~ /^OG\s+(.+)/)
				organelle = $1
			elsif (line =~ /^FT\s+NON_TER\s+/)
				print_seq=false
				# puts "#{id}   NON_TER"
			elsif (line =~ /^FT\s+NON_CONS\s+(\d+)\s+/)
				print_seq=false
				# puts "#{id}   NON_CONS"
			elsif (line =~ /^\s+([\w\s]+)/)
				seq += $1
			elsif (line =~ /^\/\//)
				seq.gsub!(/\s*/,'')
				if (seq !~ /^M/i)
					print_seq=false
				end
				newseq = false
				
				if (print_seq)
					output_file.puts ">#{id} #{description} #{organism_name} #{organelle}\n#{seq}"
					if (!isoform_hash[id].nil?)
						output_file.puts isoform_hash[id]
					end
				end
			end
		end
	end
	output_file.close
end

def load_isoform_hash(file)
	
	isoform_hash = {}
	my_fasta = ''
	acc = ''
	File.open(file).each do |line|
		line.chomp!
		if (line =~ /(^>\w+\|(\w+)\-\d\|.+)/)
			if (isoform_hash[acc].nil?)
				isoform_hash[acc]= "#{my_fasta}\n"
			else
				isoform_hash[acc]+= "#{my_fasta}\n"
			end
			my_fasta = "#{$1}\n"
			acc = $2
		else
			my_fasta += line
		end
	end
	
	return isoform_hash
end

################################################### MAIN

ROOT_PATH=File.dirname(__FILE__)

if ENV['BLASTDB'] && File.exists?(ENV['BLASTDB'])
  formatted_db_path = ENV['BLASTDB']
else # otherwise use ROOTPATH + DB
  formatted_db_path = File.expand_path(File.join(ROOT_PATH, "blast_dbs"))
end

ENV['BLASTDB']=formatted_db_path
puts "Databases will be downloaded at: #{ENV['BLASTDB']}"
puts "\nTo set the path for storing databases, execute next line in your terminal or add it to your .bash_profile:\n\n\texport BLASTDB=/my_path/\n\n"

my_array = ["human","fungi","invertebrates","mammals","plants","rodents","vertebrates"]
# my_array = ["plants","human"] # used for a shoter test

conecta_uniprot(my_array, formatted_db_path)
system('gunzip '+File.join(formatted_db_path,'*.gz'))

isoform_hash = {}
isoform_hash = load_isoform_hash(File.join(formatted_db_path, "uniprot_sprot_varsplic.fasta"))

download_ncrna(formatted_db_path)

my_array.each do |db_group|

	filter_incomplete_seqs(File.join(formatted_db_path, "uniprot_sprot_#{db_group}.dat"), isoform_hash, formatted_db_path)
	filter_incomplete_seqs(File.join(formatted_db_path, "uniprot_trembl_#{db_group}.dat"), isoform_hash, formatted_db_path)
	
	sp_fasta=File.join(formatted_db_path,"sp_#{db_group}","sp_#{db_group}.fasta")
	tr_fasta=File.join(formatted_db_path,"tr_#{db_group}","tr_#{db_group}.fasta")
	system("makeblastdb -in #{sp_fasta} -dbtype 'prot' -parse_seqids")
	system("makeblastdb -in #{tr_fasta} -dbtype 'prot' -parse_seqids")
	
end

puts "download_fln_dbs.rb has finished"
