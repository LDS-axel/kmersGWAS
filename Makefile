#Good read for making a makefile: https://stackoverflow.com/questions/2481269/how-to-make-a-simple-c-makefile"
CXX=g++
CPPFLAGS = -std=c++14 -Wall -O3 -I /ebio/abt6/yvoichek/smallproj/prefix/include/ -I ./include/ -pthread  -march=native 
#FLAGS for callgrind -g -mno-tbm 
LDFLAGS :=  -L/ebio/abt6/yvoichek/smallproj/prefix/lib -lstdc++ -lboost_program_options

SRCEXT = cpp

INCLUDEDIR := include
SRCDIR := src
BUILDIR := build
BINDIR := bin

KMC_API = $(INCLUDEDIR)/KMC/kmc_api/
OBJ_KMC = $(BUILDIR)/kmc_file.o $(BUILDIR)/kmer_api.o $(BUILDIR)/mmer.o 
OBJ_YV =  $(BUILDIR)/kmer_DB.o $(BUILDIR)/kmer_multipleDB.o $(BUILDIR)/kmer_general.o
OBJ_ALL = $(OBJ_KMC) $(OBJ_YV)


all: F_correlate_kmers_to_phenotype F_kmers_intersect_and_sort F_kmers_count_histogram F_list_kmers_found_in_multiple_DBs F_create_kmer_table

F_create_kmer_table: $(SRCDIR)/F_create_kmer_table.cpp $(OBJ_ALL)
	$(CXX) $(OBJ_ALL) $(SRCDIR)/F_create_kmer_table.cpp -o $(BINDIR)/F_create_kmer_table $(CPPFLAGS) $(LDFLAGS)

F_correlate_kmers_to_phenotype: $(SRCDIR)/F_correlate_kmers_to_phenotype.cpp $(OBJ_ALL)
	$(CXX) $(OBJ_ALL) $(SRCDIR)/F_correlate_kmers_to_phenotype.cpp -o $(BINDIR)/F_correlate_kmers_to_phenotype $(CPPFLAGS) $(LDFLAGS)
	
F_kmers_intersect_and_sort: $(SRCDIR)/F_kmers_intersect_and_sort.cpp $(OBJ_KMC) $(BUILDIR)/kmer_DB.o $(BUILDIR)/kmer_general.o 
	$(CXX) $(OBJ_KMC) $(BUILDIR)/kmer_DB.o $(BUILDIR)/kmer_general.o $(SRCDIR)/F_kmers_intersect_and_sort.cpp -o $(BINDIR)/F_kmers_intersect_and_sort $(CPPFLAGS) 

F_kmers_count_histogram: $(SRCDIR)/F_kmers_count_histogram.cpp $(OBJ_ALL) 
	$(CXX) $(OBJ_ALL) $(SRCDIR)/F_kmers_count_histogram.cpp -o $(BINDIR)/F_kmers_count_histogram $(CPPFLAGS) 

F_list_kmers_found_in_multiple_DBs: $(SRCDIR)/F_list_kmers_found_in_multiple_DBs.cpp  $(OBJ_KMC) $(BUILDIR)/kmer_DB.o $(BUILDIR)/kmer_general.o
	$(CXX) $(OBJ_KMC) $(BUILDIR)/kmer_DB.o $(BUILDIR)/kmer_general.o $(SRCDIR)/F_list_kmers_found_in_multiple_DBs.cpp -o $(BINDIR)/F_list_kmers_found_in_multiple_DBs $(CPPFLAGS) 



# Objects
$(BUILDIR)/kmer_general.o: $(SRCDIR)/kmer_general.cpp $(SRCDIR)/kmer_general.h $(OBJ_KMC)
	$(CXX) -c $(SRCDIR)/kmer_general.cpp -o $(BUILDIR)/kmer_general.o $(CPPFLAGS) 

$(BUILDIR)/kmer_DB.o: $(SRCDIR)/kmer_DB.cpp $(SRCDIR)/kmer_DB.h  $(OBJ_KMC) $(BUILDIR)/kmer_general.o
	$(CXX) -c $(SRCDIR)/kmer_DB.cpp -o $(BUILDIR)/kmer_DB.o $(CPPFLAGS) 

$(BUILDIR)/kmer_multipleDB.o: $(SRCDIR)/kmer_multipleDB.cpp $(SRCDIR)/kmer_multipleDB.h  $(OBJ_KMC) $(BUILDIR)/kmer_DB.o $(BUILDIR)/kmer_general.o $(SRCDIR)/dot_product_SSE4.inc
	$(CXX) -c $(SRCDIR)/kmer_multipleDB.cpp -o $(BUILDIR)/kmer_multipleDB.o $(CPPFLAGS) 

$(BUILDIR)/mmer.o:
	$(CXX) -c  $(KMC_API)/mmer.cpp -o $(BUILDIR)/mmer.o $(CPPFLAGS)  

$(BUILDIR)/kmer_api.o: 
	$(CXX) -c  $(KMC_API)/kmer_api.cpp -o $(BUILDIR)/kmer_api.o $(CPPFLAGS)

$(BUILDIR)/kmc_file.o:
	$(CXX) -c  $(KMC_API)/kmc_file.cpp -o $(BUILDIR)/kmc_file.o $(CPPFLAGS)




clean:
	rm $(BINDIR)/* $(BUILDIR)/* 
