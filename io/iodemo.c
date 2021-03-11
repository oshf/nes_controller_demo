#include "neslib.h"
#include "gameRes.h"

unsigned char pad;

const unsigned char palette[16]={ 0x0f,0x30,0x15,0x10,0x0f,0x04,0x1c,0x3d,0x0f,0x32,0x07,0x07,0x0f,0x16,0x16,0x16 };

void sceneSetup();
void getInput();

void main() {
  sceneSetup();
  while(1) {
    getInput();
  }
}

void sceneSetup() {
  ppu_off(); // turn screen off
  pal_bg(palette); // Set palette for background
  pal_spr(palette);  // Set palette for sprites
  vram_adr(NAMETABLE_A); // set VRAM address
  vram_unrle(gameRes); // unpack RLE
  ppu_on_all(); // turn screen on
}

void getInput() {	
  pad = pad_poll(0); // Get Controller Input
  
  ppu_wait_nmi(); // Wait until beginning of frame
  oam_clear(); // Clear buffer
  
  if(pad & PAD_A) {
	oam_spr(174,124,56,0); // Push sprite to oam
  }
  if(pad & PAD_B) {
	oam_spr(155,124,56,0);
  }
  if(pad & PAD_START) {
	oam_spr(115,126,57,0);
  }
  if(pad & PAD_SELECT) {
	oam_spr(132,126,57,0);
  }
  if(pad & PAD_UP) {
	oam_spr(84,113,55,0);
  }
  if(pad & PAD_DOWN) {
	oam_spr(84,124,55,0);
  }
  if(pad & PAD_LEFT) {
	oam_spr(79,118,58,0);
  }
  if(pad & PAD_RIGHT) {
	oam_spr(90,118,58,0);
  }
  
  if(pad != 0x00) // If pad is not at default state
  	sfx_play(0,0); // Play sound
}
