OCAMLBUILD = ocamlbuild

SOURCES = nfa.mli nfa.ml regexp.ml regexp.mli testUtils.ml
PUBLIC_SOURCES = public.ml

PUBLIC_RESULT = public.byte
VISUALIZE_RESULT = viz.byte

OCAMLLDFLAGS = -g
PACKS = oUnit,str

all: public viz

public: $(PUBLIC_RESULT)

viz: $(VISUALIZE_RESULT)

$(VISUALIZE_RESULT): $(SOURCES) viz.ml
	$(OCAMLBUILD) $(VISUALIZE_RESULT) -pkgs $(PACKS)

$(PUBLIC_RESULT): $(SOURCES) $(PUBLIC_SOURCES)
	$(OCAMLBUILD) $(PUBLIC_RESULT) -pkgs $(PACKS) 
clean:
	rm -f *.byte
	rm -f *.native
	rm -f *.cmi
	rm -f *.cmo
	rm -f output.viz output.png
	$(OCAMLBUILD) -clean
