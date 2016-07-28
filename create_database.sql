DROP TABLE IF EXISTS introns;
DROP TABLE IF EXISTS exons;
DROP TABLE IF EXISTS isoforms;
DROP TABLE IF EXISTS orphaned_cdses;
DROP TABLE IF EXISTS genes;
DROP TABLE IF EXISTS sequences;
DROP TABLE IF EXISTS organisms;
DROP TABLE IF EXISTS chromosomes;
DROP TABLE IF EXISTS intron_types;
DROP TABLE IF EXISTS tax_groups2;
DROP TABLE IF EXISTS tax_groups1;
DROP TABLE IF EXISTS tax_kingdoms;
DROP TABLE IF EXISTS orthologous_groups;

CREATE TABLE tax_kingdoms(
    id serial PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE tax_groups1(
    id serial PRIMARY KEY,
    id_tax_kingdoms INT NOT NULL,
    name VARCHAR(30) UNIQUE NOT NULL,
    typee VARCHAR(500)
);

CREATE TABLE tax_groups2(
    id serial PRIMARY KEY,
    id_tax_groups1 INT NOT NULL,
    id_tax_kingdoms INT NOT NULL,
    name VARCHAR(30) UNIQUE NOT NULL,
    typee VARCHAR(500)
);


CREATE TABLE organisms(
    id serial PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    ref_seq_assembly_id VARCHAR(20),
    annotation_release VARCHAR(200),
    taxonomy_xref VARCHAR(50),
    taxonomy_list VARCHAR(500),
    id_tax_groups2 INT,
    real_chromosome_count INT DEFAULT 0,
    db_chromosome_count INT DEFAULT 0,
    real_mitochondria BOOLEAN DEFAULT FALSE,
    db_mitochondria BOOLEAN DEFAULT FALSE,
    unknown_sequences_count INT DEFAULT 0,
    total_sequences_length BIGINT DEFAULT 0,
    b_genes_count INT DEFAULT 0,
    r_genes_count INT DEFAULT 0,
    cds_count INT DEFAULT 0,
    rna_count INT DEFAULT 0,
    unknown_prot_genes_count INT DEFAULT 0,
    unknown_prot_cds_count INT DEFAULT 0,
    exons_count INT DEFAULT 0,
    introns_count INT DEFAULT 0
);

CREATE TABLE sequences(
    source_file_name VARCHAR(50),
    refseq_id VARCHAR(20),
    version VARCHAR(50),
    description TEXT,
    lengthh INT NOT NULL DEFAULT 0,
    id_organisms INT NOT NULL,
    id_chromosomes INT,
    origin_file_name VARCHAR(100)
);

CREATE TABLE genes(
    id_organisms INT NOT NULL,
    id_sequences INT NOT NULL,
    id_orthologous_groups INT,
    name VARCHAR(40),
    backward_chain BOOLEAN DEFAULT FALSE,
    protein_but_not_rna BOOLEAN,
    pseudo_gene BOOLEAN,
    startt INT,
    endd INT,
    start_code INT,
    end_code INT,
    max_introns_count INT DEFAULT 0
);

create TABLE isoforms(
    id_genes INT NOT NULL,
    id_sequences INT NOT NULL,
    protein_xref VARCHAR(40),
    protein_id VARCHAR(100),
    product VARCHAR(250),
    note TEXT,
    cds_start INT,
    cds_end INT,
    mrna_start INT,
    mrna_end INT,
    mrna_length INT,
    exons_cds_count INT,
    exons_mrna_count INT,
    exons_length INT,
    start_codon VARCHAR(3),
    end_codon VARCHAR(3),
    maximum_by_introns BOOLEAN,

    error_in_length BOOLEAN NOT NULL DEFAULT FALSE,
    error_in_start_codon BOOLEAN NOT NULL DEFAULT FALSE,
    error_in_end_codon BOOLEAN NOT NULL DEFAULT FALSE,
    error_in_intron BOOLEAN NOT NULL DEFAULT FALSE,
    error_in_coding_exon BOOLEAN NOT NULL DEFAULT FALSE,
    error_main BOOLEAN NOT NULL DEFAULT FALSE,
    error_comment TEXT
);

create TABLE exons(
    id_isoforms INT NOT NULL,
    id_genes INT NOT NULL,
    id_sequences INT NOT NULL,

    startt INT NOT NULL,
    endd INT NOT NULL,
    lengthh INT,
    typee SMALLINT NOT NULL DEFAULT 4 /* = Unknown */,
    start_phase SMALLINT,
    end_phase SMALLINT,
    length_phase SMALLINT,
    indexx INT,
    rev_index INT,
    start_codon VARCHAR(3),
    end_codon VARCHAR(3),

    prev_intron INT DEFAULT 0,
    next_intron INT DEFAULT 0,

    error_in_pseudo_flag BOOLEAN NOT NULL DEFAULT FALSE,
    error_n_in_sequence BOOLEAN NOT NULL DEFAULT FALSE
);

create TABLE introns(
    id_isoforms INT NOT NULL,
    id_genes INT NOT NULL,
    id_sequences INT NOT NULL,

    prev_exon INT NOT NULL,
    next_exon INT NOT NULL,
    id_intron_types INT,

    start_dinucleotide VARCHAR(2),
    end_dinucleotide VARCHAR(2),

    startt INT NOT NULL,
    endd INT NOT NULL,
    lengthh INT,
    indexx INT,
    rev_index INT,
    length_phase SMALLINT,
    phase SMALLINT,

    error_start_dinucleotide BOOLEAN NOT NULL DEFAULT FALSE,
    error_end_dinucleotide BOOLEAN NOT NULL DEFAULT FALSE,
    error_main BOOLEAN NOT NULL DEFAULT FALSE,

    warning_n_in_sequence BOOLEAN NOT NULL DEFAULT FALSE
);